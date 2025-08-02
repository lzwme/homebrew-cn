class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.20.tar.gz"
  sha256 "4f51df34b89979718a98078f33b540eef753e046b72fc59c3be1d26069d805df"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eab91bf0dde9a30770d80c69ea12d34b2ce8dcdc1b3cbb151076df77764b7b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b194dcdbec1145e49680d515778c146c350f1b8541754dfdc2bf4305ea6bac40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffa92fdb5ebbdd62d33dfcd155c6d0513a025ffcdf262f4cd663792c2089c0cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bae15970e63a8a0d95178a8d534d08ffddda8b3213217d5a6b2b167c03264ca0"
    sha256 cellar: :any_skip_relocation, ventura:       "e42660a86ed18ad57a38de5e151ecf9d86a6160a7821a9314660e7cedb8928e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9973b671dc61271943d82dc4d9fe1e144cf4f8ce3f789f7ce1bbd702e1c28862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09f446f9bfab19726d8871d05804cc66d4bdba3ed081867f72ecfff057d370a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end