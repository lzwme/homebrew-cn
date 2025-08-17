class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.9.tar.gz"
  sha256 "75f0ac3bce4fc012e8198b72518db5179e903079858efce08b912d5dcc7094d3"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7ee637801204c16948d1ba544231788434b7acc0c312fc775f158b2e16e1979"
    sha256 cellar: :any,                 arm64_sonoma:  "5672d1dc2f59f29e056117962a16e1e8e384b2f53cbf8ef6f05b83eea30eb01c"
    sha256 cellar: :any,                 arm64_ventura: "a2d6c460cad9705b370160264295f63c5ae40970ce7a4ebea94ec86ed803c605"
    sha256 cellar: :any,                 sonoma:        "eb9697f1c8c50185fb2c6ecc3b0fe8de29a9a8152c5bd5dd4334ac4da74d5774"
    sha256 cellar: :any,                 ventura:       "58c1334e6ea38a1efd5d814a32fd9799476e850930eb2dee928ab63d941145be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e24f885eab5758d156b01190228f914b1b486fa1e1629b687737b0fdb313d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59131ebf4730f939015073bf4847acbf1e2cb60a687fd931323f131d6bbddb62"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"
  depends_on "zstd"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dpie=true" if OS.mac?
    args << "-Dcpu=#{cpu}" if build.bottle?

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081
    # Remove this workaround when the same is removed in `zig.rb`.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    # Avoid the Makefile for now so that we can pass `-Dcpu` to `zig build`.
    # https://code.blicky.net/yorhel/ncdu/issues/185
    system "zig", "build", *args, *std_zig_args
    man1.install "ncdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
    system bin/"ncdu", "-o", "test"
    output = JSON.parse((testpath/"test").read)
    assert_equal "ncdu", output[2]["progname"]
    assert_equal version.to_s, output[2]["progver"]
    assert_equal Pathname.pwd.size, output[3][0]["asize"]
  end
end