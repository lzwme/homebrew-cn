class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.0.1.tar.gz"
  sha256 "01b3ec7a896f5167274d10a510424a4349da8ef35402f5c6b411b1bb8cf73c8b"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e25f900ea3117d188a6f3e82a27262031a27a6c1c92d2453d79c482196b0082a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbb51d659ec10711dc718af440752d44d224d6fb2bc261bed8afa26847730919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bebe9ef72dd67b3ebc8b32c0f1ec2b8d8867671edbaed717903b2f8fd841fd55"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ee7ccc3491f25cf32af8a9af34dd297568656f4c1f6739106be852844347f65"
    sha256 cellar: :any_skip_relocation, ventura:        "e425a56f4b63e7710086612452b343871e43355f2a2177e3f25f07f5dccdc7bf"
    sha256 cellar: :any_skip_relocation, monterey:       "e30441714289c56114feeac082e7b725313b9388d4e9e3c30bca65a127b0f06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c417336e12444aae7119ec84fe39c44fa3b92bcf265a5ddbba4b9943b196c46d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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