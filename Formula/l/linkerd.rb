class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.3",
      revision: "97275dd3916c29a231d91fc1fd926fa59d2a0dac"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d875c1b37a80e8571e507daeb4d88f4e78aad0b9dcd0d05e7da8f6b0d29e2d1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f06f7537c196262ecc222cd65ab7b2a4eb456d7627c1519ac8488dcc16a879e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567239cbf9a9f7b2ab4943566e82690dbd8dca18d0f71e5594e58f382da7b879"
    sha256 cellar: :any_skip_relocation, sonoma:         "54ef440b629e302b96127114e3336a11b18bec776007018db78abea99e12b5e4"
    sha256 cellar: :any_skip_relocation, ventura:        "8d97f53f2964908a646fc74894db3fb5ce3591caadff2ebb6b5773fa5145717a"
    sha256 cellar: :any_skip_relocation, monterey:       "8aaed134569ceaa1c583d43172a38c7d08f9128da4733b21ffd3c0ae7bca7265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44831df21a19872fadc45fa353972fed2317b170c39075347d81cd317d929e4"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end