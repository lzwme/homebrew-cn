class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://ghfast.top/https://github.com/juju/juju/archive/refs/tags/v4.0.6.tar.gz"
  sha256 "2165d6e1bee2fa8ca0be86bde9a912f70c7c232e1087dc9b07675c8edaa589b6"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce954f6e1527d982aabffc9db9770bfa8054e1e076944a03649c12f061f5a0b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c515369bbd10a5cf3cfbf582e969a5c4ff7f3fb86b51c2ede32ba8b0db03878"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfb8d293a134d8a9e12099ff281134d67980d9410fb214562d5fa36541743255"
    sha256 cellar: :any_skip_relocation, sonoma:        "3146d14c3cfb5bc390c6de0ef5ee9f66a7b0e60bb018590a2bf3f37c19b7989a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a8e0fd3abe43aa741d26771745837e3e470dd821edfcf07e91813d9a876235f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af1f01b2f1af9340cdac43f4b2089a628fd8d22a436607e73a8101821497269"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end