class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://ghproxy.com/https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.2.0.tar.gz"
  sha256 "8542c665e59c1ef6bf034118eb2adef4497c51bbc82237bfcb6b4baf0c4a355b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a1bcbbe732a52ea5360c9b6748ecc80bd7748963b728ab492fb14f99893fd29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d1951af99d7f7878b97d622180bdb37ac8bf9b0b1746037fd992abc8765be1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff6d17df2da00cc0d5f39e236777b200755897c20bdff7f9467d7a662167b347"
    sha256 cellar: :any_skip_relocation, ventura:        "146627b05112b59652d8e48578be037a0c4bfccd381588c10dbd5a22c8d4d939"
    sha256 cellar: :any_skip_relocation, monterey:       "cf025a204023b1ca23e4e866c0b1e11234b2ffca62df2e66acae3f792425297d"
    sha256 cellar: :any_skip_relocation, big_sur:        "07be009cda6edb9838dfe6caf32a7f1fd2a329b827e7396e2ce095e6cb1d8dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61bb93e06805213423970560110bc6c5a0e8fe1cfae18c06aa2f38fd70f99404"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https://github.com/ReagentX/imessage-exporter/blob/develop/build.sh
    inreplace "imessage-exporter/Cargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output(bin/"imessage-exporter --version")
    assert_match "Unable to launch", shell_output(bin/"imessage-exporter --diagnostics 2>&1")
  end
end