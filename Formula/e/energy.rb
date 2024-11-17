class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https:energye.github.io"
  url "https:github.comenergyeenergyarchiverefstagsv2.4.6.tar.gz"
  sha256 "a643cfe6ccac53c1c71bd1ec6a9e070c1f5f98c86368a70a093ea556806bd3fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9dd3947f4e345da08ccd69da749df5ba9d6a08dcf15ae2db80dc181a2f4c46a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9dd3947f4e345da08ccd69da749df5ba9d6a08dcf15ae2db80dc181a2f4c46a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9dd3947f4e345da08ccd69da749df5ba9d6a08dcf15ae2db80dc181a2f4c46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bfd3a4481d1f4a7afcf25c741e261a67a45325923aae97ed71ef5daba59eeb3"
    sha256 cellar: :any_skip_relocation, ventura:       "3bfd3a4481d1f4a7afcf25c741e261a67a45325923aae97ed71ef5daba59eeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8673eb0c0a82f4c7b066e7221cec992d9ae56f208f280d60287f4564ba972e57"
  end

  depends_on "go" => :build

  def install
    cd "cmdenergy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}energy cli -v")
    assert_match "Current", output
    assert_match "Latest", output
    output = shell_output("#{bin}energy env")
    assert_match "Get ENERGY Framework Development Environment", output
    assert_match "GOROOT", output
    assert_match "ENERGY_HOME", output
  end
end