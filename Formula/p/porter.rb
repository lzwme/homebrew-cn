class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https:porter.sh"
  url "https:github.comgetporterporterarchiverefstagsv1.2.0.tar.gz"
  sha256 "53d73d6c6afb6b4bdff7072aeba4ff14738d9a09710cfed9ff5e84b649275917"
  license "Apache-2.0"
  head "https:github.comgetporterporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11cf0d1bbe48519d60db8ea4ac1ae1828484b2648a02669351b39aebd28d6b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11cf0d1bbe48519d60db8ea4ac1ae1828484b2648a02669351b39aebd28d6b7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11cf0d1bbe48519d60db8ea4ac1ae1828484b2648a02669351b39aebd28d6b7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f7f79ba1e2fdb1ec4ffa0578b640d96ca6a97fe987c12da6baeeabae2b5c6bf"
    sha256 cellar: :any_skip_relocation, ventura:       "6f7f79ba1e2fdb1ec4ffa0578b640d96ca6a97fe987c12da6baeeabae2b5c6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19fdcacb29459c665c770de54c49cd113149d5c98045d21cb857dccdebbab56b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.shporterpkg.Version=#{version}
      -X get.porter.shporterpkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdporter"
    generate_completions_from_executable(bin"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}porter --version")

    system bin"porter", "create"
    assert_predicate testpath"porter.yaml", :exist?
  end
end