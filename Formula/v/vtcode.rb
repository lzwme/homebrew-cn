class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.82.0.crate"
  sha256 "3210ab695dd95f9aee85bc3a81c668d42ed4dd85687887f4501be20c2491a256"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fce523d0ed26c1cbcc657f7317017121e9124ae58d0f4d684e543a4017091a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "570a42d57c1526f2d24d4d409618dc6a63e259f99b173ba4e977e1d180aa3cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a33eb6b4b91fbcfb668a5158dd9456d0ba7e8afb68683df54e20f19b37c06a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "6204f9a000dba17eb8304697d6f081333ce4aaaea907ce4bac5eeb5e0d3f1425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a38074103ea605bc9cb405f7a59edf5329762fb9fc341ae8bc8265094f77803a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6440646e7a6e93b22cd8ea815d5aea0113ceda4247be5d4b39cd141cab4fbf4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end