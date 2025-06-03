class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https:github.comawslabsamazon-ecr-credential-helper"
  url "https:github.comawslabsamazon-ecr-credential-helperarchiverefstagsv0.10.0.tar.gz"
  sha256 "dd97ebe79fcc488496cb6e5b2ad9f8a79b5105018c6ee02be9f80cc0df0f4ad7"
  license "Apache-2.0"
  head "https:github.comawslabsamazon-ecr-credential-helper.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d817a82ae7464778298aca84b6e213466258f6ac4c5b9e7353f1fba8f7651b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d817a82ae7464778298aca84b6e213466258f6ac4c5b9e7353f1fba8f7651b01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d817a82ae7464778298aca84b6e213466258f6ac4c5b9e7353f1fba8f7651b01"
    sha256 cellar: :any_skip_relocation, sonoma:        "2792074680b3e09f0dfb3b9944dde57426d02e5762dc13f986eb2203c79b9451"
    sha256 cellar: :any_skip_relocation, ventura:       "2792074680b3e09f0dfb3b9944dde57426d02e5762dc13f986eb2203c79b9451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64e9c2756a81777a9f28028ca958f032346cefec8988dd6c83d927c9d1fe6036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7ad2c445a7a05f1572cb8c80e143f1d735627e85866ed8e7fa3a50542f51da7"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    (buildpath"GITCOMMIT_SHA").write tap.user
    system "make", "build"
    bin.install "binlocaldocker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}docker-credential-ecr-login", 1)
    assert_match(^Usage: .*docker-credential-ecr-login, output)
  end
end