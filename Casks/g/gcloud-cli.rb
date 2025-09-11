cask "gcloud-cli" do
  arch arm: "arm", intel: "x86_64"

  version "538.0.0"
  sha256 arm:   "6405cad49d552d2ef563752f2562a028bca0bae9ab50d373a0b30bee1ca1b0ce",
         intel: "931d880f72b46bb9d97fa2dc6dd5693aa3afc2260096cb3c9bf7c57ff99ad602"

  url "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-#{version}-darwin-#{arch}.tar.gz"
  name "Google Cloud CLI"
  desc "Set of tools to manage resources and applications hosted on Google Cloud"
  homepage "https://cloud.google.com/cli/"

  livecheck do
    url "https://cloud.google.com/sdk/docs/install-sdk"
    regex(/latest\s*gcloud\s*CLI\s*version\s*\(v?(\d+(?:\.\d+)+)\)/i)
  end

  auto_updates true
  depends_on formula: "python@3.12"

  google_cloud_sdk_root = "#{HOMEBREW_PREFIX}/share/google-cloud-sdk"

  installer script: {
    executable: "google-cloud-sdk/install.sh",
    args:       [
      "--quiet",
      "--usage-reporting", "false",
      "--bash-completion", "true",
      "--path-update", "true",
      "--install-python", "false",
      "--update-installed-components"
    ],
  }
  binary "google-cloud-sdk/bin/bq"
  binary "google-cloud-sdk/bin/gcloud"
  binary "google-cloud-sdk/bin/gsutil"
  bash_completion "google-cloud-sdk/completion.bash.inc", target: "google-cloud-sdk"
  zsh_completion "google-cloud-sdk/completion.zsh.inc", target: "_google_cloud_sdk"

  preflight do
    FileUtils.cp_r staged_path/"google-cloud-sdk/.", google_cloud_sdk_root, remove_destination: true
    FileUtils.rm_r(staged_path/"google-cloud-sdk")
    FileUtils.ln_s google_cloud_sdk_root, (staged_path/"google-cloud-sdk")
  end

  postflight do
    # Allow existing shell profiles to work by linking the current version to the `latest` directory.
    unless (latest_path = staged_path.dirname/"latest").directory?
      FileUtils.ln_s staged_path, latest_path, force: true
    end
    # Install required external dependencies via virtualenv
    if File.exist?(File.join(Dir.home, "/.config/gcloud/virtenv"))
      puts "deleting existing virtual env before enabling virtual env with current Python version"
      system_command "#{google_cloud_sdk_root}/bin/gcloud",
                     args:      ["config", "virtualenv", "delete", "-q"],
                     reset_uid: true
    end
    system_command  "#{google_cloud_sdk_root}/bin/gcloud",
                    args:      ["config", "virtualenv", "create", "--python-to-use",
                                "#{HOMEBREW_PREFIX}/opt/python@3.12/libexec/bin/python3"],
                    reset_uid: true
    system_command  "#{google_cloud_sdk_root}/bin/gcloud",
                    args:      ["config", "virtualenv", "enable"],
                    reset_uid: true

    system_command  "#{google_cloud_sdk_root}/bin/gcloud",
                    args:      ["version"],
                    reset_uid: true
  end

  uninstall trash: staged_path.dirname/"latest"

  zap trash: [
    "#{google_cloud_sdk_root}.staging",
    google_cloud_sdk_root,
  ]
end