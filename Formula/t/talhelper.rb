class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.10.tar.gz"
  sha256 "09e65744a03d602a0991e38c55de792fa401ffef55a01651ee11b526529d2f27"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cf62080ac3f0bc8609c4028f8daf887e94e9911679d6867b3a95f826d4ea177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cf62080ac3f0bc8609c4028f8daf887e94e9911679d6867b3a95f826d4ea177"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cf62080ac3f0bc8609c4028f8daf887e94e9911679d6867b3a95f826d4ea177"
    sha256 cellar: :any_skip_relocation, sonoma:        "50d44eb079a5f000502b380ec27ff32273c19af75f996495694016e434c133fe"
    sha256 cellar: :any_skip_relocation, ventura:       "50d44eb079a5f000502b380ec27ff32273c19af75f996495694016e434c133fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c9122e32a715b230f9e47e550969cafcc67d6dfb5edc47f97c1d49437d81a1"
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