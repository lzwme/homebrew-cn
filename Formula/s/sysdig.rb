class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://ghfast.top/https://github.com/draios/sysdig/archive/refs/tags/0.40.1.tar.gz"
  sha256 "f4d465847ba8e814958b5f5818f637595f3d78ce93dbc3b8ff3ee65a80a9b90f"
  license all_of: [
    "Apache-2.0",
    { any_of: ["GPL-2.0-only", "MIT"] },                  # `falcosecurity-libs`, driver/
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # `falcosecurity-libs`, userspace/libscap/compat/
  ]
  revision 1
  head "https://github.com/draios/sysdig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "e6d849344d12af8cc207bf2a9d6cf200b9272378f481e25ce6e3bb16233ddf09"
    sha256 arm64_sequoia: "15b17706de92083b72925bbc785a15be7ed29b3d1df8ba98e617ffd5204e3770"
    sha256 arm64_sonoma:  "f92dd74c63fac65554143296e773595e48e1a4fb963dd986653887a9aea22ef8"
    sha256 sonoma:        "57434977bf946bfee35565161587bbf52fada59bc005a0a56e21d391983e848b"
    sha256 arm64_linux:   "7ac5bc839761962f1f6c9adaf5ad3866670206274f54289eea77c7152af9e0f4"
    sha256 x86_64_linux:  "692e1f253e7b6db5f1d6d9c887ee7c5605b65f4169b5a483672956ce42cc812b"
  end

  # FIXME: switch to brewed `falcosecurity-libs`
  # once sysdig supports the most recent version
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "valijson" => :build
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "ncurses" # for `newterm` function
  depends_on "re2" # Move to `on_macos` block once it depends on `falcosecurity-libs`
  depends_on "tbb" # Move to `on_macos` block once it depends on `falcosecurity-libs`
  depends_on "uthash" # for `falcosecurity-libs`
  depends_on "yaml-cpp"

  uses_from_macos "zlib" # for `falcosecurity-libs`

  # for `falcosecurity-libs`
  on_linux do
    depends_on "abseil"
    depends_on "curl"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "protobuf"
  end

  link_overwrite "etc/bash_completion.d/sysdig"

  resource "falcosecurity-libs" do
    url "https://ghfast.top/https://github.com/falcosecurity/libs/archive/refs/tags/0.20.0.tar.gz"
    sha256 "4ae6ddb42a1012bacd88c63abdaa7bd27ca0143c4721338a22c45597e63bc99d"
  end

  def install
    falco_prefix = libexec/"falcosecurity-libs"

    # Copied installation options from `falcosecurity-libs` formula
    resource("falcosecurity-libs").stage do
      args = %W[
        -DBUILD_DRIVER=OFF
        -DBUILD_LIBSCAP_GVISOR=OFF
        -DBUILD_LIBSCAP_EXAMPLES=OFF
        -DBUILD_LIBSINSP_EXAMPLES=OFF
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_RPATH=#{falco_prefix/"lib"}
        -DCREATE_TEST_TARGETS=OFF
        -DFALCOSECURITY_LIBS_VERSION=#{resource("falcosecurity-libs").version}
        -DUSE_BUNDLED_DEPS=OFF
      ]
      # TODO: remove on next release which has dropped option
      # https://github.com/falcosecurity/libs/commit/d45d53a1e0e397658d23b216c3c1716a68481554
      args << "-DMINIMAL_BUILD=ON" if OS.mac?

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: falco_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Remove once brewed `falcosecurity-libs` is used
    ENV.prepend_path "PKG_CONFIG_PATH", falco_prefix/"lib/pkgconfig"

    # Workaround to find some headers
    # TODO: Fix upstream to use standard paths, e.g. sinsp.h -> libsinsp/sinsp.h
    ENV.append_to_cflags "-I#{falco_prefix}/include/falcosecurity/libsinsp"
    ENV.append_to_cflags "-I#{falco_prefix}/include/falcosecurity/driver" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
    ]

    # FIXME: remove after switching to brewed `falcosecurity-libs`
    args << "-DCMAKE_INSTALL_RPATH=#{falco_prefix}/lib"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # More info on https://gist.github.com/juniorz/9986999
    resource "homebrew-sample_file" do
      url "https://ghfast.top/https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
      sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
    end

    testpath.install resource("homebrew-sample_file").files("sample.scap")
    output = shell_output("#{bin}/sysdig --read=#{testpath}/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end