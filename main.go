package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

func main() {
	var namespace string
	flag.StringVar(&namespace, "namespace", "", "kubernetes namespace for secret")
	var secretName string
	flag.StringVar(&secretName, "secret", "", "kubernetes secret name")
	flag.Parse()

	fmt.Printf("reading secret '%s' in namespace '%s'\n", secretName, namespace)

	config, err := rest.InClusterConfig()
	if err != nil {
		log.Fatal(err)
	}
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatal(err)
	}

	secret, err := clientset.CoreV1().Secrets(namespace).Get(context.Background(), secretName, metav1.GetOptions{})
	if err != nil {
		panic(err)
	}
	log.Println("kubernetes secret Data field")
	for key, value := range secret.Data {
		log.Printf("%s = %s\n", key, value)
	}

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	sig := <-sigs
	log.Printf("Exiting due to %v", sig)
}
