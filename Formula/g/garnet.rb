class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://ghfast.top/https://github.com/microsoft/garnet/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "d04787afa9d82b6c7645091e49b371157c712f78fed231d7c32c613af829c4b4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f04ec6c508ee73d9f852c0f6f00db9957d8a777eea1e99061688df9cbf8b89c"
    sha256 cellar: :any, arm64_tahoe:       "d89bb8c9011080ce8832d233c5fab22db2433234f6447d5253748eff58fb0d16"
    sha256 cellar: :any, arm64_sequoia:     "eeafaa8fe639a097ee9f49cc6f871d647871648834987986d4f79ba6a9a6670c"
    sha256 cellar: :any, arm64_linux:       "f8c51dc631c01d255630e29b088df7fb1f425b0a49ff6b27670e9dd53a79869c"
    sha256 cellar: :any, x86_64_linux:      "aa44d247a03a083e7dc3f26db4558b18fb945a2ccfa1036ad15fac054212acfc"
  end

  depends_on "rust" => :build
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

    # Drop the prebuilt BfTree binaries; msbuild rebuilds the library with cargo and prefers its copy
    rm_r Dir["libs/native/bftree-garnet/runtimes/*"]

    # The device csproj ships every prebuilt runtime it finds, so drop the ones we can't use
    native_rid = ("linux-#{Hardware::CPU.arm? ? "arm64" : "x64"}" if OS.linux?)
    device_runtimes = buildpath/"libs/storage/Tsavorite/cs/src/core/Device/runtimes"
    device_runtimes.each_child { |rid| rm_r(rid) if rid.basename.to_s != native_rid }

    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        args = %w[
          -DUSE_URING=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
        system "cmake", "--build", "build"
        native_dir = device_runtimes/native_rid/"native"
        cp "build/libnative_device.so", native_dir/"libnative_device.so"
        cp "build/libnative_device.so", native_dir/"libnative_device_libaio.so"
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
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{formula_opt_bin("valkey")}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end