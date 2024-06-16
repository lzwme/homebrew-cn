class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https:janet-lang.org"
  url "https:github.comjanet-langjanetarchiverefstagsv1.35.0.tar.gz"
  sha256 "81d619245040de151572f1c4cd01d4380aae656befed280d35e1fe3a4dd7b0af"
  license "MIT"
  head "https:github.comjanet-langjanet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de183961304f2196ac0694ea3ad3805a891283568d88886416df2e2d178cce8c"
    sha256 cellar: :any,                 arm64_ventura:  "8e63ada934289b35acef76a55b217a17f22ceefd7e70743b9f1b471674fd72ea"
    sha256 cellar: :any,                 arm64_monterey: "f07c54da5ef430afdaefd893d8cbc06ce5fbe6e0e06eed71b607e1d524446442"
    sha256 cellar: :any,                 sonoma:         "8f35882bd64b75eb4835361ffa2565ed39646bdf17e68f8e5c951523c331ec4b"
    sha256 cellar: :any,                 ventura:        "1d20c5f37b21282409d5674fdc835a66dcf984c65d4ff2c83848d24b9061615d"
    sha256 cellar: :any,                 monterey:       "6ccc9193179ebda18febf8b9eda84e28202638810fa0de6f8d1434f23fad7cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112bfe4647ff39bbb6bb3c1cbd14f0a34660e87fb2612bbc14608c402913f6fe"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https:github.comjanet-langjpmarchiverefstagsv1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX"binjpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX"binjpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}jpm show-paths")
  end
end