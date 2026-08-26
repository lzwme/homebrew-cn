class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "30975a2f1b1ca07f132ee2641f904b6e30c64b3a05d5ed6edb27cf7bdd35b1ac"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7f11ba4891cc6d61c99755509c7b4f8d38c2f19e58423444e8424401d6606a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bdfbd1724750df2310b92495f231a0762a11c9030ac797a6365e97d9b81f534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adfbefcd7070c40f3a530df1e77d16bfa8845d20ddb4cd8bab72b2720d36287d"
    sha256 cellar: :any_skip_relocation, sonoma:        "982c866840d956a46ff5f4d70af9b21551824bdb5937226417665993aa1be5de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "292b3812578b63dc59255743b6740bede217a4657e405799eb57944854fa423e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c599602d657e1bdf3feaf6b50803af4fd46c2a7412212956501eedbfeb28158"
  end

  depends_on "zig" => :build

  conflicts_with "fx", because: "both install an `fx` binary"

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "Fx needs access to Vercel AI Gateway", output
  end
end