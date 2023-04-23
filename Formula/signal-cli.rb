class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghproxy.com/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.11.9.tar.gz"
  sha256 "1fcf8812409742f054099712fde9923440eb8203d16ce29d62acf100d213175e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f112dea3d78567b2c987ec273e4b9753e0b48a304bec33fba490904545d78a8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e07dd7eae5e69b2a82fd30ea43e08b10ce8c86d231e3e6aecd9d4c85f8db44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2920e0710b930ed7c3a59b29a5b240f7ca7573b1d8864c24458419b6d0441a2"
    sha256 cellar: :any_skip_relocation, ventura:        "98a7a889ce1da3cb8617ca7bd33b735ed5d47a1af8ab1dcb815e998bbf23d8c5"
    sha256 cellar: :any_skip_relocation, monterey:       "fe020a5263f57e9aef6be6c08546cd8b609e545f1789ffdfe494ce464d4b512a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2854e5b0ec5b1ec0d6e80e6e306105b9743170481b255c2e6d5ccfba484951d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd290d3bb6241afba9203256a0d313071fbc1a71a522ce99894ba2535dd9a80"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https://github.com/signalapp/libsignal/blob/#{libsignal-client.version}/rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "zip" => :build

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # rust-lang/rust-bindgen#2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `libsignal`
  # crate's dependency `boring-sys` uses `bindgen` v0.62.0 or newer.
  on_linux do
    depends_on "llvm@15" => :build # For `libclang`, used by `boring-sys` crate
  end

  # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/libsignal-client-X.X.X.jar'
  resource "libsignal-client" do
    url "https://ghproxy.com/https://github.com/signalapp/libsignal/archive/refs/tags/v0.22.0.tar.gz"
    sha256 "fed130fe6192e7cb422d8278a5ee4a7451ea62f5cbfd68bbacd5350513e0bad8"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#building-libsignal-client-yourself

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      odie "#{r.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != r.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni.so", "libsignal_jni.dylib", "signal_jni.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "shared/resources" do
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni")
        end
      end
    end
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}/signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", io.read
  end
end