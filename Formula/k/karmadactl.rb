class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.12.0.tar.gz"
  sha256 "6fa45d3124f7537157364f9decaa0cde613f85b86d529ed62f103812082bf1bc"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "878eaf721f993dde17a020fd9ca32119defde1ecf8e3ae95bc8714a5cef2b1aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5ffddd40aa91bc78c85fb87ed5268b4cd01233e85f905d2b15f05c30748b2f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2525c33ed9bfa5be9c87fed405cfcfb39ab0af9c3fc90467c2519a15c82ae5f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc2f4f81f8f79b29d4620caec29be2105be3b34c743330300eb33b878fae9eb6"
    sha256 cellar: :any_skip_relocation, ventura:       "a091c4c14e56a4180ffe9414e96cfa610ba299bdd8ba60e56a819e51ff4bd8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e166742382704c26a836b131ebcc8573c5c66b9844573b01447c32809121763"
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