class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.9.tar.gz"
  sha256 "87ec0735839eba17d68d8690d3749144f9ad1eab2614a5861c41befe79f03cde"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cde7d3032bea454de164aae17c82a33cf6c1450c45487e33a7b58443fa30a7c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95588213669285cd90e3fa3df4b313fe05abf8fc5f054afce4d1d419075d932a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47c2213c5bbce142dde501d609ec8818d51d2da71c30f7cc8ab4d411b5f59903"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c552dc3ff23b7c5ea48e968e8e36806067aec365716250f9b56e6040805ae3af"
    sha256 cellar: :any,                 x86_64_linux:      "9dad4ba7b4eb87f484e41e7615735626a9630b2a8048630ab7eb3bc1a8422166"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end