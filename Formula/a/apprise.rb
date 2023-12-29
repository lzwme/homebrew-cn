class Apprise < Formula
  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/9c/24/24356d021be60b63c96248a2202153932bfa6c6dee6c29a36e86e9cd7c78/apprise-1.7.0.tar.gz"
  sha256 "d8d5710d3c952586c2cfadf7ce9ea0fe60b80eca93946497e3ef18f3cc0eec19"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "542aedba4a2b821a3858dac045509dd78b57e84f3424b6ff8debdab1c70803ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50a9bb5a400e75c7dd95684615430dd12e88f91ef71ece40023dc42a40bda9e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38f522daba2d292610f52a3667dd2344c1e5ace1dda5b451a5ece2b5644bed44"
    sha256 cellar: :any_skip_relocation, sonoma:         "80d81e4fd4efd5cb1e25c4168a082ddac33181dec477bb0d19808b86601057dc"
    sha256 cellar: :any_skip_relocation, ventura:        "490254a63a25fb1c7f0b8f5c269a1e671e8ab06972c0481d1dc70d1cb061a0a7"
    sha256 cellar: :any_skip_relocation, monterey:       "cdcdb26064bf85e7f0ed64964de3adcaa51e8d339cb30f62c2d5392608d58cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068b3cf33308da33238c0324bb5b488566065f7e83e35c55f8946b9b1e15d6d6"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-markdown"
  depends_on "python-requests-oauthlib"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    # Setup a custom notifier that can be passed in as a plugin
    brewtest_notifier_file = "#{testpath}/brewtest_notifier.py"
    apprise_plugin_definition = <<~EOS
      from apprise.decorators import notify

      @notify(on="brewtest")
      def my_wrapper(body, title, *args, **kwargs):
        # A simple test - print to screen
        print("{}: {}".format(title, body))
    EOS

    File.write(brewtest_notifier_file, apprise_plugin_definition)

    charset = Array("A".."Z") + Array("a".."z") + Array(0..9)
    brewtest_notification_title = charset.sample(32).join
    brewtest_notification_body = charset.sample(256).join

    # Run the custom notifier and make sure the output matches the expected value
    assert_match \
      "#{brewtest_notification_title}: #{brewtest_notification_body}", \
      shell_output(
        "#{bin}/apprise" \
        + " " + %Q(-P "#{brewtest_notifier_file}") \
        + " " + %Q(-t "#{brewtest_notification_title}") \
        + " " + %Q(-b "#{brewtest_notification_body}") \
        + " " + '"brewtest://"' \
        + " " + "2>&1",
      )
  end
end