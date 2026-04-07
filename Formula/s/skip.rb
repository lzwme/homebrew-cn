class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.4.tar.gz"
  sha256 "43797ea54af9a65d94ce45534a4948c7cc729e5ab3173faf97ed9ce303890985"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "6521c7936af33ce020b1b0bbfe441b2df5d7cea5c02964ccc44dfb4f4bf62d13"
    sha256 arm64_sequoia: "ee7f037c4fdfb104b770d51a882ee7fd24b6a776143d11cf347ff9b6a909909a"
    sha256 arm64_linux:   "73616dba3e5081a837d6298981c752510a62508d441ee13272a59c48c7983f75"
    sha256 x86_64_linux:  "f6e01984983460e07ca3c524922fb423cdb466ec09d104477f38183a2648a2ae"
  end

  depends_on xcode: ["16.4", :build]
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