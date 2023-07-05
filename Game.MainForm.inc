procedure InitializeComponent;
    begin
        self.components := new System.ComponentModel.Container();
        self.MainPictureBox := new System.Windows.Forms.PictureBox();
        self.MainTimer := new System.Windows.Forms.Timer(self.components);
        self.ScoreLabel := new System.Windows.Forms.Label();
        self.HighScoreLabel := new System.Windows.Forms.Label();
        (System.ComponentModel.ISupportInitialize(self.MainPictureBox)).BeginInit();
        self.SuspendLayout();
        // 
        // MainPictureBox
        // 
        self.MainPictureBox.BackColor := System.Drawing.Color.White;
        self.MainPictureBox.Location := new System.Drawing.Point(0, 0);
        self.MainPictureBox.Name := 'MainPictureBox';
        self.MainPictureBox.Size := new System.Drawing.Size(600, 150);
        self.MainPictureBox.TabIndex := 0;
        self.MainPictureBox.TabStop := false;
        self.MainPictureBox.MouseDown += MainPictureBox_MouseDown;
        // 
        // MainTimer
        // 
        self.MainTimer.Interval := 1;
        self.MainTimer.Tick += MainTimer_Tick;
        // 
        // ScoreLabel
        // 
        self.ScoreLabel.AutoSize := true;
        self.ScoreLabel.BackColor := System.Drawing.Color.Transparent;
        self.ScoreLabel.Font := new System.Drawing.Font('Unispace', 11.9999981, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(0)));
        self.ScoreLabel.ForeColor := System.Drawing.Color.FromArgb((System.Int32((System.Byte(83)))), (System.Int32((System.Byte(83)))), (System.Int32((System.Byte(83)))));
        self.ScoreLabel.Location := new System.Drawing.Point(541, 0);
        self.ScoreLabel.Name := 'ScoreLabel';
        self.ScoreLabel.Size := new System.Drawing.Size(59, 19);
        self.ScoreLabel.TabIndex := 1;
        self.ScoreLabel.Text := '00000';
        self.ScoreLabel.TextAlign := System.Drawing.ContentAlignment.MiddleRight;
        // 
        // HighScoreLabel
        // 
        self.HighScoreLabel.AutoSize := true;
        self.HighScoreLabel.BackColor := System.Drawing.Color.Transparent;
        self.HighScoreLabel.Font := new System.Drawing.Font('Unispace', 11.9999981, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(0)));
        self.HighScoreLabel.ForeColor := System.Drawing.Color.FromArgb((System.Int32((System.Byte(115)))), (System.Int32((System.Byte(115)))), (System.Int32((System.Byte(115)))));
        self.HighScoreLabel.Location := new System.Drawing.Point(452, 0);
        self.HighScoreLabel.Name := 'HighScoreLabel';
        self.HighScoreLabel.Size := new System.Drawing.Size(89, 19);
        self.HighScoreLabel.TabIndex := 2;
        self.HighScoreLabel.Text := 'HI 00000';
        self.HighScoreLabel.TextAlign := System.Drawing.ContentAlignment.MiddleRight;
        self.HighScoreLabel.Visible := false;
        // 
        // MainForm
        // 
        self.BackColor := System.Drawing.Color.White;
        self.ClientSize := new System.Drawing.Size(600, 150);
        self.Controls.Add(self.HighScoreLabel);
        self.Controls.Add(self.ScoreLabel);
        self.Controls.Add(self.MainPictureBox);
        self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
        self.MaximizeBox := false;
        self.MaximumSize := new System.Drawing.Size(616, 189);
        self.MinimumSize := new System.Drawing.Size(616, 189);
        self.Name := 'MainForm';
        self.StartPosition := System.Windows.Forms.FormStartPosition.CenterScreen;
        self.Text := 'Chrome Dino';
        self.Load += MainForm_Load;
        self.KeyDown += MainForm_KeyDown;
        self.KeyUp += MainForm_KeyUp;
        (System.ComponentModel.ISupportInitialize(self.MainPictureBox)).EndInit();
        self.ResumeLayout(false);
        self.PerformLayout();
    end;
