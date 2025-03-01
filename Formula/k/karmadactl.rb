class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.13.0.tar.gz"
  sha256 "1e09fec8df5d2f4095013da7fe6b42737e2667fbbb15a79b6e3f27e5024ff814"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa0be5b9935304291f6ee4a63139a92b812eb00f64568ac838b64eef5a9ecfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e150df9a8876c4e73b7d89d147863b864305958803ebe73e6837c2b67256cbab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0124637b9d32982431facb0809aa8cd48ba8a8fa36bdf3d31c7b291c7cfa3c3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4033e68273f880f1f4842948297b2fb17adb556242a7a52a02795a677d923cd5"
    sha256 cellar: :any_skip_relocation, ventura:       "6a62a74532493aba2940e75d6d9c3d90bc74c643314f6b61c29dedd49eb17e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8a09bfde5bb42316bc0f75a5be104ea11281a59fe8a2c2d626a8e1fda5be5a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkarmada-iokarmadapkgversion.gitVersion=#{version}
      -X github.comkarmada-iokarmadapkgversion.gitCommit=
      -X github.comkarmada-iokarmadapkgversion.gitTreeState=clean
      -X github.comkarmada-iokarmadapkgversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkarmadactl"

    generate_completions_from_executable(bin"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}karmadactl version")
  end
end