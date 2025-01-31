class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https:github.combazelbuildbuildtools"
  url "https:github.combazelbuildbuildtoolsarchiverefstagsv8.0.2.tar.gz"
  sha256 "0063f317e135481783f3dc14c82bc15e0bf873c5e9aeece63b4f94d151aeb09f"
  license "Apache-2.0"
  head "https:github.combazelbuildbuildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43cacf413992901fcb9fc2cceebdadb9761d72463026dc9f529fd5ca64976fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43cacf413992901fcb9fc2cceebdadb9761d72463026dc9f529fd5ca64976fc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43cacf413992901fcb9fc2cceebdadb9761d72463026dc9f529fd5ca64976fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "254d8783b7d6e8ad9632c31ba87bcd8983efc740a08203b448bf9b24ee4e9a95"
    sha256 cellar: :any_skip_relocation, ventura:       "254d8783b7d6e8ad9632c31ba87bcd8983efc740a08203b448bf9b24ee4e9a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f12629fcaa9e6b988dc6c2db70e9580ef795890ba857b0ea4bcdce4735b8f24"
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