class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "1e3f2f75d162d2b5eb397019df6e63ce9f2af97a79e2f08406fa635bdccf2740"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba22eaa7d2a4152610fed78e22da33e5dd298b9db6916cf45b8a8ee245ac6abd"
    sha256 cellar: :any,                 arm64_sequoia: "993395898a910225fca4b201f7a3b540b569f3f06280fd832e4242caf77e519d"
    sha256 cellar: :any,                 arm64_sonoma:  "f9457d42dc26ae600d7b2847807c67b87857b5ddc48cea42e83f9f2b7bc319f8"
    sha256 cellar: :any,                 sonoma:        "9105fca2e31388f39ed3ee081b93b4e58948bf66a01754290b51a1ca6a57540c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53237eea582e2b2dbc6a69ddcde4b195eb8eedbb977e2456cbb20a167451b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771ace3f711ca6d232fe69948631ba48a180b994eb70d2495cfa3f47a669bfd0"
  end

  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        # Fix to cmake version 4 compatibility
        arg = "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        system "cmake", "-S", ".", "-B", "build", arg, *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
      end
    end

    dotnet = Formula["dotnet"]
    # .NET 10 flags IL3000 here even though Garnet falls back to AppContext.BaseDirectory.
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:WarningsNotAsErrors=IL3000
      -p:EnableSourceLink=false
      -p:EnableSourceControlManagerQueries=false
    ]
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos

    # Remove non-native library
    rm libexec/"liblua54.so" if OS.linux? && Hardware::CPU.arm?
  end

  test do
    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{Formula["valkey"].opt_bin}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end