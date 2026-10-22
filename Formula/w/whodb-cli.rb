class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  license "Apache-2.0"

  stable do
    url "https://ghfast.top/https://github.com/clidey/whodb/archive/refs/tags/0.136.0.tar.gz"
    sha256 "87c3833c997675750d78d0194bcd37bfa3fcf18d5e1ab96b0488ebded7bbef92"

    resource "baml" do
      url "https://ghfast.top/https://github.com/BoundaryML/baml/archive/refs/tags/0.226.2.tar.gz"
      sha256 "09aa8182dd9bb674a6aa78733052b35720c2d9c763422e579fcd2b846f3e26b9"

      livecheck do
        url "https://ghfast.top/https://raw.githubusercontent.com/clidey/whodb/#{LATEST_VERSION}/core/go.mod"
        regex(%r{github\.com/boundaryml/baml\s+v?(\d+(?:\.\d+)+)}i)
      end
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "71c7915d6af60541cdb366821737bdec8ff4e528e61c548304a4e8a1c7b131be"
    sha256 cellar: :any, arm64_tahoe:       "d3d973cf2160c0c18bf1ad3ad6266dd5865ea84d7fb3dc2b3ec05b50cacd19df"
    sha256 cellar: :any, arm64_sequoia:     "b7bfd826f60ef88e7ce09e7ff92a1b690951b6c07ca6f9d003ff8a2dac202525"
    sha256 cellar: :any, arm64_linux:       "5536b80fbd48f4b775f5c08536eb4d650ac2d9d8b737252db7c78546f44330ef"
    sha256 cellar: :any, x86_64_linux:      "83b0dadec4148a679926378dc0320570ca658e16d647e2f127873ea5933e0898"
  end

  head do
    url "https://github.com/clidey/whodb.git", branch: "main"

    resource "baml" do
      url "https://github.com/BoundaryML/baml.git", branch: "main"
    end
  end

  depends_on "go" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "rust" => :build

  deny_network_access!

  def baml_version
    File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?(\d+(?:\.\d+)+)}i, 1]
  end

  def fetch
    resource("baml").stage("baml")
    system "git", "-C", "baml", "checkout", baml_version if build.head?
    system "go", "mod", "download"
    # Not using std_cargo_fetch_args as cbindgen needs all targets
    system "cargo", "fetch", "--locked", "--manifest-path", "baml/engine/language_client_cffi/Cargo.toml"
  end

  def install
    ENV["BAML_LIBRARY_DISABLE_DOWNLOAD"] = "true"
    ENV["BAML_LIBRARY_PATH"] = libexec/shared_library("libbaml_cffi")
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["PROTOC_GEN_GO_PATH"] = formula_opt_bin("protoc-gen-go")/"protoc-gen-go"

    system "cargo", "build", "--lib", "--release", "--manifest-path", "baml/engine/language_client_cffi/Cargo.toml",
           *std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    libexec.install shared_library("baml/engine/target/release/libbaml_cffi")

    ldflags = %W[
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(output: libexec/"whodb", ldflags:), "./cli"
    (bin/"whodb").write_env_script libexec/"whodb", BAML_LIBRARY_PATH: ENV["BAML_LIBRARY_PATH"]
    bin.install_symlink bin/"whodb" => "whodb-cli"

    generate_completions_from_executable(bin/"whodb", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb version")

    output = shell_output("#{bin}/whodb connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end