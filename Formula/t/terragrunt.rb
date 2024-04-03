class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.55.21.tar.gz"
  sha256 "61645457ec73d320eb6e562dd9884f611a2b1eb123c6d9f88c3006438d132401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed7f4f2d450afc00e247c7b77e5c0e5a8aec26ab43c43e33981a15783627f611"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5edec8c4a994e22f7295abf86aff7398c5725f88e594371b3920d9951c0d0768"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ca53344a1e66142ef0aefc41233287c617bf379af6274d2a2769ad8d7d4691"
    sha256 cellar: :any_skip_relocation, sonoma:         "261745513441e47981ee4a78c7467dab2b30380220b54d24a231318ed7ec1093"
    sha256 cellar: :any_skip_relocation, ventura:        "0c5a0f3334fa7ebc361167537caf768a7649740dffe2747f36e617891711c5ac"
    sha256 cellar: :any_skip_relocation, monterey:       "1de9e8199435057e1a1f9559fd9857dd7fd850eb1946535a8f9660f245ebe17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b816adeec49d7601cac257f9dbcf800cb2f5d9fe8863a44368da772549a46b5"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end