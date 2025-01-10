class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https:github.combazelbuildbuildtools"
  url "https:github.combazelbuildbuildtoolsarchiverefstagsv8.0.0.tar.gz"
  sha256 "1a9eaa51b2507eac7fe396811bc15dad4d15533acc61cc5b0d71004e1d0488cb"
  license "Apache-2.0"
  head "https:github.combazelbuildbuildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "132a863445e3ed0acd5f3719d528959c7e5d3307bc7e1cde4a4f8f1eba68d3ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "132a863445e3ed0acd5f3719d528959c7e5d3307bc7e1cde4a4f8f1eba68d3ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "132a863445e3ed0acd5f3719d528959c7e5d3307bc7e1cde4a4f8f1eba68d3ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e1471aa04f0dc6f922a0d9a8363900a6f7b4c791b42545112d7e9715df6a007"
    sha256 cellar: :any_skip_relocation, ventura:       "9e1471aa04f0dc6f922a0d9a8363900a6f7b4c791b42545112d7e9715df6a007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda3f04cc16b6e490151f8450272a44f93ddac9ca80a3ab99e9271af28e674e4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".buildozer"
  end

  test do
    build_file = testpath"BUILD"

    touch build_file
    system bin"buildozer", "new java_library brewed", ":__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end