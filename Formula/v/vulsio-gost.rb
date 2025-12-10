class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://ghfast.top/https://github.com/vulsio/gost/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "00f1da4210b20c4225b78408e1bc519f38340039c4a82b6c14b115b5c805bf6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef1e4f34fc896f7cd417d261fa2e2c3f81f4d8ce7da45e1496d3a326a9244486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef1e4f34fc896f7cd417d261fa2e2c3f81f4d8ce7da45e1496d3a326a9244486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1e4f34fc896f7cd417d261fa2e2c3f81f4d8ce7da45e1496d3a326a9244486"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c21122932ebe6f1b65067dae6f12118f845347251774e7f959e6d41fd6a304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a01361bfdfd62c862e1382a9cbd3b19e0c89e4b63ec382a30846f2b35cb3a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394315676580dff1b3828ff24a4842a069b6420479cce77569ab5c5ff850dedb"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gost")

    generate_completions_from_executable(bin/"gost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end