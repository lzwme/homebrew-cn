class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.45.0.tar.gz"
  sha256 "8fd4d3e74e035449b7ad8a27d6df20682f3cc51fe2db2c19370cf409665ddca0"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed6905072e76e36dff658b88f85997eeb05aac09af1a0aa233d509b9bfd41a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6905072e76e36dff658b88f85997eeb05aac09af1a0aa233d509b9bfd41a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed6905072e76e36dff658b88f85997eeb05aac09af1a0aa233d509b9bfd41a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "588d2a11bbf7cea022ab6fb662d78de0998d8a9fa758a00a5ff18aa809f08df5"
    sha256 cellar: :any_skip_relocation, ventura:       "588d2a11bbf7cea022ab6fb662d78de0998d8a9fa758a00a5ff18aa809f08df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd51139befd39286be5f0dce551c991c235c0cf354cd1521a4a6306bcb3e3b54"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end