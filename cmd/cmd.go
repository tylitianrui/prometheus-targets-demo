package cmd

import (
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:              "",
	Short:            "",
	PersistentPreRun: func(cmd *cobra.Command, args []string) {},
	PreRun:           func(cmd *cobra.Command, args []string) {},
	Run: func(cmd *cobra.Command, args []string) {
		cmd.Help()
	},
	PostRun:           func(cmd *cobra.Command, args []string) {},
	PersistentPostRun: func(cmd *cobra.Command, args []string) {},
}

func Execute() error {
	if err := rootCmd.Execute(); err != nil {
		// handle  error
		return err
	}
	return nil
}
