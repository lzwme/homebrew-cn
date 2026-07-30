class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://ghfast.top/https://github.com/rochacbruno/marmite/archive/refs/tags/0.4.1.tar.gz"
  sha256 "e92669708373bc96be893770e87c6edd0b7e016b3b6685f14e396f27c3de90fd"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7e957edbeab9717027db7a52db63f5a3cf57341bec5feda4b08e3a145159738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be2a0f9a7112276146645bc1c3c0795df235eac3b47e60a8e36b002e7ac9b677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377859dbbec7c06bbd11c6f88334aca5ba886bc2c653e18cf6d2952f24ddb395"
    sha256 cellar: :any_skip_relocation, sonoma:        "1adbb01a999c7b27668adcc110dea8392bd9ded2b6c6334b82eca298bc92d72b"
    sha256 cellar: :any,                 arm64_linux:   "f3f7a94276ea78ea1782ca3b99f1923c49cb6388d789ec0447dbcbf7aebb18af"
    sha256 cellar: :any,                 x86_64_linux:  "8d6cfa0e7c80023ad82c11772078b793e1ec18ea3baf7fe1dc17dd4b38d9c41f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmite --version")

    system bin/"marmite", testpath/"site", "--init-site"
    assert_path_exists testpath/"site"
  end
end