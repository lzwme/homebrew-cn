class Carl < Formula
  desc "Calendar for the command-line"
  homepage "https://github.com/b1rger/carl"
  url "https://ghfast.top/https://github.com/b1rger/carl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "82518ea8fbd89985c40591a1b2c030b969829e9ce12ac52cd4923bd852dcd884"
  license "MIT"
  head "https://github.com/b1rger/carl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fafc29ae2ab8e50cc0f7d547010cf7fa7c3a02fa69bb96f5a895afda858e5077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24e089317286996916a752bbe9db465f4be90e7e266f0caa35635982086d9e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9be8efd8f1f3a08c2cd598eef4014d479c0884befdd20720a1f0a39355a61013"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3bf67b636554ec5e2d7dd4d56d299ca46f04bc402af5cfba091be09769d00a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5836b6a32a188ff23e42be42af8773a984e7aa9cd6404d2b64c876d45d2ed24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a4d985cb1d18aaaabe14401811aafa79245f504a816ec200b09600d647fabcb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Su Mo Tu We Th Fr Sa", shell_output("#{bin}/carl --sunday")
    assert_match "Mo Tu We Th Fr Sa Su", shell_output("#{bin}/carl --monday")

    output = shell_output("#{bin}/carl --year")
    %w[
      January February March April May June July
      August September October November December
    ].each do |month|
      assert_match month, output
    end
  end
end