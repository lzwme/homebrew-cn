class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https:www.openshift.com"
  url "https:github.comopenshift-onlineocm-cliarchiverefstagsv0.1.74.tar.gz"
  sha256 "ab0896ff42cfe5b648dcf295770249cc0c0a6de232ba064ec9bd04163b94938d"
  license "Apache-2.0"
  head "https:github.comopenshift-onlineocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c329f9a1da6f9c5f1c71365270c2e1571f189c343552dbc77391716d1d99d63c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31bff45d2df066e3fc1620aaf4ed49c9692e2d17427f53b2713563a30e475820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82aee35abfaf0618a15963a23955306039d7dee86993066b636083a6057b918d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d0976c7f9e522f37a9347970967d62c65713b261c758a4eb1b8761ba52d6c61"
    sha256 cellar: :any_skip_relocation, ventura:        "95b1e188d9ada07d49a4c5be78ba38ab1394a53648b14f6dcd29cf07d6e3ab79"
    sha256 cellar: :any_skip_relocation, monterey:       "fdda7d27aaa104cc4bd2aa60814466479aa8815858b16cfe989062403b1d01c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f9b346c7bde391dfcc02b3f2b9ecb188933a648dd9687e1b1a441c3b555d99"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), ".cmdocm"
    generate_completions_from_executable(bin"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath"ocm.json"
    system bin"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end