class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https:github.comcantinomcfly"
  url "https:github.comcantinomcflyarchiverefstagsv0.8.3.tar.gz"
  sha256 "1d9f4e3b55fdac8b9c3007c19875bd308eb79dd473d371647e82250a52446d53"
  license "MIT"
  head "https:github.comcantinomcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f76ead2fb94fd8f52f3c02284584d7f9957ca182f49ab8cd40fc7aacc8961015"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "334ca3ca7167be17d8d770629c69493b50fe05a2af955ba3176c4ffdc66bd6d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fcc44e577aa103eceb0ac01d93289a63eb0ca1e1fbd53eb197a7f7ba0ab57fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "72f66b5e8b7a9ff94d67a0a6499d7b1ec0d92c74d99a02784fd0be2ad71ea36e"
    sha256 cellar: :any_skip_relocation, ventura:        "85470d6b8c12fad537ae106132d4754b3b6654a0706ba422c3f013f4bf9d01f3"
    sha256 cellar: :any_skip_relocation, monterey:       "ec52b628b50f5ad6f5c3248784a95baf169c3d1a6da361896e5a70fb0a23cfa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c550636d81c991cc02ed34ffd16ee6063499b2479b7b8a0cf5f2eb678fa707d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}mcfly --version")
  end
end