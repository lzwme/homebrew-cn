class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://ghfast.top/https://github.com/mroth/scmpuff/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "3733e5af8608331835affb7530c1baf88066e80e72bf78becdaa090a26cfc5f0"
  license "MIT"
  head "https://github.com/mroth/scmpuff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268d35b9474a9c66f4ef2026bc10dad07840a138e220ce5e1e5a27ebf3d4c543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "268d35b9474a9c66f4ef2026bc10dad07840a138e220ce5e1e5a27ebf3d4c543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268d35b9474a9c66f4ef2026bc10dad07840a138e220ce5e1e5a27ebf3d4c543"
    sha256 cellar: :any_skip_relocation, sonoma:        "007a8e74d69b60156364e70bbb98dfd3357eec896466958bf308d914ce2c1faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cab3c3476b3a1a11a9c9cdedc7d6fbefcc29b21374f956ebdd497f3c3efcf03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c91c5b365e2d273de4667653d0112a3a7f5b9e5426b382cf026df8e796c47417"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scmpuff --version 2>&1")

    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end