class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://ghproxy.com/https://github.com/sigstore/gitsign/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "b9b82840db5181e44e9979b464844c34dba4cb1f8cfedbc3650d5347f0dcf5c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a0a0a9944c3f319773664e495eefa47d19f807147bd02ea5e80c20cb6fda1fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1db80c0322fc64632467b7706d0639e6af1b94030bc77f36d2fa39be67559d2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c6b2869c1cab16c1aca63a32e395ff31b5bbc6331f6cc551dc7e8ec5847528d"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb1fc81b4d96e0e987bcb03975e3c9248c6d237b39a05875a614d7ecc8a61d77"
    sha256 cellar: :any_skip_relocation, ventura:        "8428e7db15803dbceaca12b521f57597c195fe084bbc9efe80be41d75a385d5b"
    sha256 cellar: :any_skip_relocation, monterey:       "161563660563b72d22a9502054c49b09e7175ad8545e064613ad0155fc275630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a18dd6025ec22aa81cd984fd391725b9fdc0205823bfc2a3d474b67facb503"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end