class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.22.tar.gz"
  sha256 "1ac2c9afc9e9cfa021efbe628ab96ddbdc313a0ab9b005de3827edcd6db983c2"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "401ade68d3a38994b53d20504ac2f486712314eca36f621ba64f728560f7c075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "401ade68d3a38994b53d20504ac2f486712314eca36f621ba64f728560f7c075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "401ade68d3a38994b53d20504ac2f486712314eca36f621ba64f728560f7c075"
    sha256 cellar: :any_skip_relocation, sonoma:        "2748d556ba6ed43ec799a20b7284593fe32e6682a6da34f701f201c16d83912a"
    sha256 cellar: :any_skip_relocation, ventura:       "2748d556ba6ed43ec799a20b7284593fe32e6682a6da34f701f201c16d83912a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9144d4b2b59f0aed284386dfdc12a219292ab7d82d6275e13a5ff068f132be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end