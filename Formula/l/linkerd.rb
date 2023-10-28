class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.14.2",
      revision: "2f25cdeeb5a433d10bbce81d58f7f652ae96d44e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1428867e959030dd5e49223b1c5f7ee66841ae05dd430d5161afc04c704d921"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba3463a566caf5d5e5cea1b67d323ff6c1689356f9422f8c6ce52378d366976f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d447765b8a04c5267df3ec4350e20f1a015c19a22a0479faa40116c09025cb15"
    sha256 cellar: :any_skip_relocation, sonoma:         "47614e3175ef335db5aa3fdf766cfffc30c3fb3a207a8778a024e440ff89346b"
    sha256 cellar: :any_skip_relocation, ventura:        "681cd27ef758c74c17155025bb7545e372d63dad062d3f88c4b2b46e97f85f7b"
    sha256 cellar: :any_skip_relocation, monterey:       "791a27da9ff7519cac7f4b25b404948ee207cc65b8e117a4c69d94267d55a4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33f082d24e7ef50eec2ec71bca084ee998be8089c0ae2cc94027fe62f53d7ca"
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