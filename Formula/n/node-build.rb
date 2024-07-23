class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.6.tar.gz"
  sha256 "d5f1e0cc785687677a5da62c3004c696a62b767109d058f62c6a48224716bbd3"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3627657ad15aa733fbc6c764ecd0a2175be336454cf77b5f0049841dc5a9f653"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3627657ad15aa733fbc6c764ecd0a2175be336454cf77b5f0049841dc5a9f653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3627657ad15aa733fbc6c764ecd0a2175be336454cf77b5f0049841dc5a9f653"
    sha256 cellar: :any_skip_relocation, sonoma:         "3627657ad15aa733fbc6c764ecd0a2175be336454cf77b5f0049841dc5a9f653"
    sha256 cellar: :any_skip_relocation, ventura:        "3627657ad15aa733fbc6c764ecd0a2175be336454cf77b5f0049841dc5a9f653"
    sha256 cellar: :any_skip_relocation, monterey:       "3627657ad15aa733fbc6c764ecd0a2175be336454cf77b5f0049841dc5a9f653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827a627dacc6c0f371bdf2a470acc3af734f108e5a47318105d8b5441e4574c9"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end