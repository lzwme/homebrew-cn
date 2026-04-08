class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.4.tar.gz"
  sha256 "43797ea54af9a65d94ce45534a4948c7cc729e5ab3173faf97ed9ce303890985"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "c42c7d855e14c6da7a8ef492aacd5cbfcb1ed7634094bdc382a1161e2432bf6b"
    sha256                               arm64_sequoia: "9b738ec25348e83b3735483886e5b77d138b85719e1c55f917b56c66a125226c"
    sha256                               arm64_sonoma:  "946fdd7a70432f3080bcd6ae0d962a8050a6f9a3bcd6a84db943e4820d0a4b11"
    sha256 cellar: :any_skip_relocation, sonoma:        "46a32103d9fee098131a26dbc97deb128684b3fdbc41ab787f1d88df2ae28367"
    sha256                               arm64_linux:   "3a8df3164d3cee87a84c10b3e98857628715f54e1c69f4111b215799b3504379"
    sha256                               x86_64_linux:  "44e7bd72504bbfe5ba706c3b686a4971945af74fadea5978b315b3deb205dd27"
  end

  depends_on xcode: :build
  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.8.4.tar.gz"
    sha256 "b7f19e076025e10b00831d2649f2cfd61ef6f06caf1c864a27aaeced162077de"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "SkipRunner"
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end