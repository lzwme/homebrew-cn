class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.9.tar.xz"
  sha256 "72de9d278f74d95d320ec7b0d745296f582264799eab908260dbea0ce8e08f83"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "53732a9e3489221517f6fe2a461ae4d66cf82aee39b38404da060b859883a6eb"
    sha256 arm64_ventura:  "19f7c882a366cbf93890a9ea0883dd3b22e59111f245d74a518e101f3897e731"
    sha256 arm64_monterey: "5fb64e52f4926897796acec85b4841347a2318d068487e1a790acd901913a763"
    sha256 sonoma:         "6e0669d2a386bb810d9cb7819578a922d9dbe0ff75478e5c65061f3dc2f0f322"
    sha256 ventura:        "c4ee12af45a2274a2298edfc217d6e0eb31d9dc1988b65f6d0391f77999ac1bb"
    sha256 monterey:       "e9c04522573375f197b719bdad07ba85554c9e0e835124912d9a5722db1be07c"
    sha256 x86_64_linux:   "66ce931bda54ba4c4c584a8cb0704f70452a5b6c6944b818ad0e597f6759e18f"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "tradcpp"

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.6.tar.bz2"
    sha256 "4dcf5a9dbe3c6ecb9d2dd05e629b3d373eae9ba12d13942df87107fdc1b3934d"
  end

  def install
    ENV.deparallelize

    # imake runtime is broken when used with clang's cpp
    cpp_program = Formula["tradcpp"].opt_bin/"tradcpp"
    (buildpath/"imakemdep.h").append_lines <<~EOS
      #define DEFAULT_CPP "#{cpp_program}"
      #undef USE_CC_E"
    EOS

    inreplace "imake.man", /__cpp__/, cpp_program

    # also use gcc's cpp during buildtime to pass ./configure checks
    ENV["RAWCPP"] = cpp_program

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    resource("xorg-cf-files").stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{HOMEBREW_PREFIX}/include"
      system "./configure", "--with-config-dir=#{lib}/X11/config",
                            "--prefix=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    # Use pipe_output because the return code is unimportant here.
    output = pipe_output("#{bin}/imake -v -s/dev/null -f/dev/null -T/dev/null 2>&1")
    assert_match "#{Formula["tradcpp"].opt_bin}/tradcpp", output
  end
end