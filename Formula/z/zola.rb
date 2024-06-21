class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https:www.getzola.org"
  url "https:github.comgetzolazolaarchiverefstagsv0.19.0.tar.gz"
  sha256 "0c1651e06608eab31d0fb60d5a2d8afc94cff6644f34c6b6bda31eb76e79a7a0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4a5ef339df9a9e8ee0048009d84de69e23c114229a66c2f7be506c12475c3af"
    sha256 cellar: :any,                 arm64_ventura:  "4c68b69e6fde6402a399e8e63678d6d66b4e5371ffaafe4a4772e6ec8feb0d13"
    sha256 cellar: :any,                 arm64_monterey: "e672a6e19051fb2291a5e2372da994b28c647dc39a61eb3307e30d2c9f56e4a8"
    sha256 cellar: :any,                 sonoma:         "fa97f5c00fb24bfe98fa63d6a994981eeeea25028c0e80cbdd5bbfcd3234df0c"
    sha256 cellar: :any,                 ventura:        "e214d171d8a51f7440cb4230ab789739106bb54ba080b69bffcde367654c8296"
    sha256 cellar: :any,                 monterey:       "147d37d25d063f31706b7b9faae725e801f8a1334bb11639dedc5441d830f25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d35ec69575727e5131049e9235c2cb1c4dafb55240f8983f99333893101e993"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "native-tls", *std_cargo_args

    generate_completions_from_executable(bin"zola", "completion")
  end

  test do
    system "yes '' | #{bin}zola init mysite"
    (testpath"mysitecontentblog_index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath"mysitetemplatessection.html").write <<~EOS
      {{ section.content | safe }}
    EOS

    cd testpath"mysite" do
      system bin"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.<p>",
      (testpath"mysitepublicblogindex.html").read.strip
  end
end