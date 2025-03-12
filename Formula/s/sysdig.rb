class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https:sysdig.com"
  url "https:github.comdraiossysdigarchiverefstags0.40.1.tar.gz"
  sha256 "f4d465847ba8e814958b5f5818f637595f3d78ce93dbc3b8ff3ee65a80a9b90f"
  license "Apache-2.0"
  head "https:github.comdraiossysdig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "eb1dce084f4165754b69538c6b8e454c9aeec3b615c8183c80f448b0bcf74ca8"
    sha256                               arm64_sonoma:  "3a19ff09d40e20b06229ddc66b887d5c39c7ca52c3e9153b7170ce3778fde5f1"
    sha256                               arm64_ventura: "2e529abfbb23fe431f8ec0f6ce1a6704eb3e359327e91aee202a0e055ca987b4"
    sha256                               sonoma:        "887232ecdaa980a68cea3c023ba358212b4446b73a194610c982f9ee7f473d89"
    sha256                               ventura:       "23914115de4402ed85a7f94eefea6cc242ff572cee6a42d2c6156cedf15febbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea6b2ec1e8bf9cfec26c4c3300c9ff1cf09abacf885d95d0473c27748a8cb6b"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "falcosecurity-libs"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "ncurses" # for `newterm` function
  depends_on "yaml-cpp"

  on_macos do
    depends_on "re2"
    depends_on "tbb"
  end

  def install
    # Workaround to find some headers
    # TODO: Fix upstream to use standard paths, e.g. sinsp.h -> libsinspsinsp.h
    ENV.append_to_cflags "-I#{Formula["falcosecurity-libs"].opt_include}falcosecuritylibsinsp"
    ENV.append_to_cflags "-I#{Formula["falcosecurity-libs"].opt_include}falcosecuritydriver" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DDIR_ETC=#{etc}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # More info on https:gist.github.comjuniorz9986999
    resource "homebrew-sample_file" do
      url "https:gist.githubusercontent.comjuniorz9986999rawa3556d7e93fa890a157a33f4233efaf8f5e01a6fsample.scap"
      sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
    end

    testpath.install resource("homebrew-sample_file").files("sample.scap")
    output = shell_output("#{bin}sysdig --read=#{testpath}sample.scap")
    assert_match "tmpsysdigsample", output
  end
end