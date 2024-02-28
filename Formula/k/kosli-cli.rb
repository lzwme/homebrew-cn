class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.8.1.tar.gz"
  sha256 "cdd5f298f4bb88b2c5c96cecc21858bd609c99d5be96ed13c1751dc8ae445bf5"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c477ad21e50daf8ca8eb64b88305e5ce7ae85caa86f1f5ffe7c54e58d9d80d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb34d6b4492d927fffcdd6bc448ec538ad5932372f73d3cb8abc87f03ebd82d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68afd320ae53eae4c9f4b991909bb8c567eb232b5cdc004ec3b6c1c9830d9568"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e67d93ace117370ec2c401cee25c42c10b645ef3a0d96f26f463be7427519ce"
    sha256 cellar: :any_skip_relocation, ventura:        "e9102b5b0c3940817225b907dae9da7a70c42e8ef3add119b314daee7c9fa46d"
    sha256 cellar: :any_skip_relocation, monterey:       "03c0d40ed1b5d63d7775312a9306c155a72d6207381b07b6bc6c75ce4c8303fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8258ee48ce7b95124620379089a27c60f142331654e6d44d61cc5cebf1f15da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags: ldflags), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end