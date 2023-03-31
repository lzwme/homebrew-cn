class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://ghproxy.com/https://github.com/asciinema/agg/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0eb9c4b664fb4c81b7b58b574f6876fdc648ce57da36d7d168365b7fbccb488b"
  license "Apache-2.0"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1be817b0833772748fa9c244b0b27e0cff04c41ef8a4ecb9ffb7a603f9a7daf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4713cad1bf7c7f41dbbbb2bf9b62839f8ff8e562f490706263d0d96e8c99ab7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "783ebb49745111f6c4401c274c51745ac88dda5a6cb1ea7d41255f4d94b721c8"
    sha256 cellar: :any_skip_relocation, ventura:        "760cb65a13970dd05d62312b038029890f31c129ae02bfea6460bde7c7df596b"
    sha256 cellar: :any_skip_relocation, monterey:       "d189d3199bd96a66f7b564cb0751378ea73a186a679a6121bf4ea33dcf8ebef4"
    sha256 cellar: :any_skip_relocation, big_sur:        "96bba88231de0eeb2ac2e8aa73a35fa20d70c16e475641610a872af259612f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8c183013d9026ff8d066fcad7c5fbfba7ecae7b452d4a0b2bcb12663b62220"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cast").write <<~EOS
      {"version": 2, "width": 80, "height": 24, "timestamp": 1504467315, "title": "Demo", "env": {"TERM": "xterm-256color", "SHELL": "/bin/zsh"}}
      [0.248848, "o", "\u001b[1;31mHello \u001b[32mWorld!\u001b[0m\n"]
      [1.001376, "o", "That was ok\rThis is better."]
      [2.143733, "o", " "]
      [6.541828, "o", "Bye!"]
    EOS
    system bin/"agg", "--verbose", "test.cast", "test.gif"
    assert_predicate testpath/"test.gif", :exist?
  end
end