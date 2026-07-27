class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://ghfast.top/https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "9c6d2e0a7540d24a1f94b9e9ee8b55db4971b5723aec4cfe79a77b46885b4ac5"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eaf487288c878aa1b126169cb2f10add781315b4311194c9c3f6aaf11ecb5dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7165480b81d108e82e69572aaf4688a4edde411df8d5809b93471164806a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c682fae20ac0a27e7265a6251a1cb129dd9741eda94bfa1d155fa0a7527d6064"
    sha256 cellar: :any_skip_relocation, sonoma:        "14bf589f8c9275c4170083d214b0814f00406be50f4141535b0131dfb5f4c958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6e32bc6fdab6c81728f05874bad0e003360b57d356fb445657b234e4489ed5"
    sha256 cellar: :any,                 x86_64_linux:  "af06b4ad4ea945084f1277d8e32d02befcc0bdb179b9ef6ebae4dfc4bc7334ff"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt \"What is 1+1\"")
    assert_match("2", output.strip)
  end
end