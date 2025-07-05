class AcloudguruSandbox < Formula
  desc "Command-line tool to manage A Cloud Guru sandboxes and configure credentials"
  homepage "https://github.com/nicerloop/acloudguru-sandbox"
  version "0.0.1"
  license "BSD-3-Clause"

  on_macos do
    if Hardware::CPU.intel?
      url "https://ghfast.top/https://github.com/nicerloop/acloudguru-sandbox/releases/download/v0.0.1/acloudguru-sandbox_Darwin_x86_64.tar.gz"
      sha256 "caf9c31384cb757b1af47bcc0b8fb7934a6fb9e08e30730bcde083e35504cdf4"
    end
    if Hardware::CPU.arm?
      url "https://ghfast.top/https://github.com/nicerloop/acloudguru-sandbox/releases/download/v0.0.1/acloudguru-sandbox_Darwin_arm64.tar.gz"
      sha256 "729bf588025ac0abffb5605c6a8f5c6f906e480d0e56094a1920b0be26a4ceb6"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://ghfast.top/https://github.com/nicerloop/acloudguru-sandbox/releases/download/v0.0.1/acloudguru-sandbox_Linux_arm64.tar.gz"
      sha256 "02d4d8e39bf3ec35c9532d0717574288ae23923d751e6388a8e0e57a77119d55"
    end
    if Hardware::CPU.intel?
      url "https://ghfast.top/https://github.com/nicerloop/acloudguru-sandbox/releases/download/v0.0.1/acloudguru-sandbox_Linux_x86_64.tar.gz"
      sha256 "fd0a9b6236965674bfceb4e2576912d97ab6d784db14fc89cae3ffeb286fcc3a"
    end
  end

  def install
    bin.install "acloudguru-sandbox"
  end
end