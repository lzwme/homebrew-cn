cask "google-cloud-sdk" do
  arch arm: "arm", intel: "x86_64"

  version "462.0.1"
  sha256 arm:   "b4ee8946fe7df9428d9100267f97b89e92294263b6c96db1cbfd1b90613d08d7",
         intel: "95bfa447004ea828753ecf6f49bd71a6aedc8b614e40d85150b13bed1230359e"

  url "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-#{version}-darwin-#{arch}.tar.gz"
  name "Google Cloud SDK"
  desc "Set of tools to manage resources and applications hosted on Google Cloud"
  homepage "https://cloud.google.com/sdk/"

  livecheck do
    url "https://cloud.google.com/sdk/docs/install-sdk"
    regex(/google-cloud-cli-(\d+(?:\.\d+)+)/i)
  end

  auto_updates true
  depends_on formula: "python@3.11"

  google_cloud_sdk_root = "#{HOMEBREW_PREFIX}/share/google-cloud-sdk"

  installer script: {
    executable: "google-cloud-sdk/install.sh",
    args:       [
      "--quiet",
      "--usage-reporting", "false",
      "--bash-completion", "false",
      "--path-update", "false",
      "--rc-path", "false",
      "--install-python", "false"
    ],
  }
  binary "google-cloud-sdk/bin/anthoscli"
  binary "google-cloud-sdk/bin/bq"
  binary "google-cloud-sdk/bin/docker-credential-gcloud"
  binary "google-cloud-sdk/bin/gcloud"
  binary "google-cloud-sdk/bin/git-credential-gcloud.sh", target: "git-credential-gcloud"
  binary "google-cloud-sdk/bin/gsutil"
  binary "google-cloud-sdk/completion.bash.inc",
         target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/google-cloud-sdk"
  binary "google-cloud-sdk/completion.zsh.inc",
         target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_google_cloud_sdk"

  preflight do
    FileUtils.cp_r staged_path/"google-cloud-sdk/.", google_cloud_sdk_root, remove_destination: true
    (staged_path/"google-cloud-sdk").rmtree
    FileUtils.ln_s google_cloud_sdk_root, (staged_path/"google-cloud-sdk")
  end

  postflight do
    # HACK: Allow existing shell profiles to work by linking the current version to the `latest` directory.
    unless (latest_path = staged_path.dirname/"latest").directory?
      FileUtils.ln_s staged_path, latest_path, force: true
    end
  end

  uninstall delete: staged_path.dirname/"latest"

  zap trash: [
    "#{google_cloud_sdk_root}.staging",
    google_cloud_sdk_root,
  ]

  caveats <<~EOS
    To add gcloud components to your PATH, add this to your profile:

      for bash users
        source "$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"

      for zsh users
        source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
        source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

      for fish users
        source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"

  EOS
end