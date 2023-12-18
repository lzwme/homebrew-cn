class GitCredentialKeepassxc < Formula
  desc "Helper that allows Git (and shell scripts) to use KeePassXC as credential store"
  homepage "https:github.comfrederick888git-credential-keepassxc"
  url "https:github.comFrederick888git-credential-keepassxcreleasesdownloadv0.14.0macos-latest-minimal.zip"
  sha256 "de8ccd9d48a4d9f6b4b726c5df7118a9238166672bd0e2fb3433d3c38f301fc4"

  def install
    bin.install Dir["*"]
  end

  test do
    system "#{bin}git-credential-keepassxc", "--version"
    assert_equal "git-credential-keepassxc #{version}\n", `#{bin}git-credential-keepassxc --version`
  end
end