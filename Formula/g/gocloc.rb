class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https:github.comhhattogocloc"
  url "https:github.comhhattogoclocarchiverefstagsv0.5.3.tar.gz"
  sha256 "d5f875df523bb8cc884d9e118de609f0b8eca50a3c6f6c220ad01118da3387ce"
  license "MIT"
  head "https:github.comhhattogocloc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f40f1c0fca393b31141e5c023aed4140ad794b29ba00ba0d492abd381232a05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f40f1c0fca393b31141e5c023aed4140ad794b29ba00ba0d492abd381232a05e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f40f1c0fca393b31141e5c023aed4140ad794b29ba00ba0d492abd381232a05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7d4e4477d71e3e14fce82f869ad284153ca991e8718506ccb930cfd0d6daa9d"
    sha256 cellar: :any_skip_relocation, ventura:       "e7d4e4477d71e3e14fce82f869ad284153ca991e8718506ccb930cfd0d6daa9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4aef5724fea748da99937ff0de07a5f6eb8a653fcaffe0685be6b91ff868b29"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgocloc"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    C

    assert_equal "{\"languages\":[{\"name\":\"C\",\"files\":1,\"code\":4,\"comment\":0," \
                 "\"blank\":0}],\"total\":{\"files\":1,\"code\":4,\"comment\":0,\"blank\":0}}",
                 shell_output("#{bin}gocloc --output-type=json .")
  end
end