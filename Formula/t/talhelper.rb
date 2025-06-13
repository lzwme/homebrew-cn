class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.29.tar.gz"
  sha256 "e04b6740245a749f78f8927006e5e0ed389fec4f306e105127f3f0982ca09d33"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eca7fdeba266cfa4101e60bd9892d62beb7acf4e369b807246b05192d8cec88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eca7fdeba266cfa4101e60bd9892d62beb7acf4e369b807246b05192d8cec88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eca7fdeba266cfa4101e60bd9892d62beb7acf4e369b807246b05192d8cec88"
    sha256 cellar: :any_skip_relocation, sonoma:        "86c1c4fa7f0895664c73536dc78e6beeae24a8fe4341756f0379d3decc0b105b"
    sha256 cellar: :any_skip_relocation, ventura:       "86c1c4fa7f0895664c73536dc78e6beeae24a8fe4341756f0379d3decc0b105b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9321cadb677d6f367a66ef39c1a45d09e2d86015275701527178f2ef905dc0"
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