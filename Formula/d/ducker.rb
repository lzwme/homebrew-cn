class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https:github.comrobertpsoaneducker"
  url "https:github.comrobertpsoaneduckerarchiverefstagsv0.4.0.tar.gz"
  sha256 "dc63b9755f40a68dbca9137f1feffe4750da7571cee1c3e3b646baada1569cc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422f19fc7953a82d2313437a09e38efee094f2e8fa2f1ab66e248f8639dc4b20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b08a9a4a8ed4f7a07b95f2b938abedbb0f893cd934fc62c4399fb5feb68d45d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d64f783433cd68aa759a77a134ca57e2568bea39b9b7ea92534a7ea11b90da35"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ea40e9df5b71f29a4b455c86c29b5313cc278f7126bb9fe3f968f9e278c521"
    sha256 cellar: :any_skip_relocation, ventura:       "b49d76cb152ac231c520a3e9da2a858859deb708bac8bce08a668efc9e70bbce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29b64eee0b545661ea3354d8c4abc8098439069af1e1b9334221c20c3e047341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7133eb6dcf3b64f9fea8dbe7c43557b14202e3c659be7b53724cf25ec75646e8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"ducker", "--export-default-config"
    assert_match "prompt", (testpath".configduckerconfig.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}ducker --version")
  end
end