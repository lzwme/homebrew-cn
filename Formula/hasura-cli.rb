require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.22.1.tar.gz"
  sha256 "d8cad28a7b542f69365c91ee77b5dd86e62b166948aefced39aaf377b217aec1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7633f00e8752ff4e0271d210fc60855e85056ed86c064a04b25d375d2f86464"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b9c194d42ff783836a5eaa46874d1d876900c082fc6e97ce2bbf07f5dd75d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54a3111ff95c70ef534008b00398465f84bfb8520c246699aebdad2b7bfdf58a"
    sha256 cellar: :any_skip_relocation, ventura:        "5b7795a5995f55fab670733e92cf24967934e78cf8b4a640691c50ea4467b680"
    sha256 cellar: :any_skip_relocation, monterey:       "82f0f2d86310ddd6da3c162145751d1ae9d260bea635a2ef34f9e5ec845e5a4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3591cdea33b0f7ac5ba2faf41fe57190293600895c5a6216df74211aa86d583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1377c8aa31ec4b35101c1e6924340930e173505e29f22be2ad4bf1b94a12406"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags: ldflags), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end