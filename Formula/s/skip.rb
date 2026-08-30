class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.8.tar.gz"
  sha256 "a3d3933148a291784f6e85ff7581f15a4cd6112fd349b08c8335d4c939804edf"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "d63b9b76ebbf37adf9eeb0397440ab405291b73376e8118f238c36ddcff96691"
    sha256 arm64_sequoia: "b7ec6595f98a2f891676aa9a0b46b3330edd87687dc3a9fe5f720d1a97d5c2e9"
    sha256 arm64_sonoma:  "7519d0652345209433032d0b3f0185dda9c056f390e0ace2a4821814298ec015"
    sha256 arm64_linux:   "27e94675a5c6978eaf0c745ef9211d767cbdf9c67a8f2cba63cf15552a53b2c0"
    sha256 x86_64_linux:  "8fe164e607f9ef8fb26589b7199757e631a34ed3a3afadcf6d72cbd3617c05ad"
  end

  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.8.tar.gz"
    sha256 "774d78513e6e975cd97c89f00aed9e60e795a7dbb4a8232bfc0ccfaa8e96dacf"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    system "swift", "build", "--product", "SkipRunner", *std_swift_args
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