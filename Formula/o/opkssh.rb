class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://ghfast.top/https://github.com/openpubkey/opkssh/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5bf25b289703a25a3070dd31b9cb26da108ef81a5a2dc819eea8b7dfb2ff91f1"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bac75950e9bd86e30240acb92bb44bb5fb2e011da143e376c463e7c9c1f96e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bac75950e9bd86e30240acb92bb44bb5fb2e011da143e376c463e7c9c1f96e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bac75950e9bd86e30240acb92bb44bb5fb2e011da143e376c463e7c9c1f96e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4dfbeb2489ea629158503fb8bf8c7e20f2070e3fd52b79b758e71dbf7cc9b51"
    sha256 cellar: :any_skip_relocation, ventura:       "a4dfbeb2489ea629158503fb8bf8c7e20f2070e3fd52b79b758e71dbf7cc9b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7deae5ce7021fe08b64a620299da764d98f764ed3463771d965527ff0bfe45b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end