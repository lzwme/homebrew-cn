class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.15.tar.gz"
  sha256 "328ee8a90ce147e8e438d38004c3546dad6c2bdf4c2846a0ed3657617d35e1eb"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531efc255e674029400f32cf8d1d637ba08328ee5e91f02df7cf3b4acf27519c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531efc255e674029400f32cf8d1d637ba08328ee5e91f02df7cf3b4acf27519c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "531efc255e674029400f32cf8d1d637ba08328ee5e91f02df7cf3b4acf27519c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a785b77a6a26ba3566b6d0d00ab3808e97294588a8772baf658e06b4a8e20115"
    sha256 cellar: :any_skip_relocation, ventura:       "a785b77a6a26ba3566b6d0d00ab3808e97294588a8772baf658e06b4a8e20115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e4942d2cd05d5296bd46d74727f3651d7f3cc80db848e23552d4b2a4f66aad"
  end

  depends_on "go" => :build

  def install
    # https:github.comgoretkredressblobdevelopMakefile#L11-L14
    gore_version = File.read(buildpath"go.mod").scan(%r{goretkgore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}redress version")

    test_module_root = "github.comgoretkredress"
    test_bin_path = bin"redress"

    output = shell_output("#{bin}redress info '#{test_bin_path}'")
    assert_match(Main root\s+#{Regexp.escape(test_module_root)}, output)
  end
end